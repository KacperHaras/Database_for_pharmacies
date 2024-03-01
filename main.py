from tkinter import *
from tkinter import ttk
from tkinter import messagebox as mb
from tkinter import messagebox
from ttkthemes import ThemedTk
from datetime import datetime
import psycopg2

theme='xpnative'
root = ThemedTk(theme=theme, background=True)
root.title('Apteki')
root.geometry('700x600')


# connection to the database
conn = psycopg2.connect(
    dbname='AptekiProj',
    user='postgres',
    password='************',
    host='localhost',
    port='5432'
    )

# Function to fetch data from the database
def fetch_data(query):
    if not query:
        raise ValueError('Nie podano zapytania.')

    c = conn.cursor()
    c.execute(query)
    records = c.fetchall()
    column_names = [desc[0] for desc in c.description]
    c.close()
    return column_names, records


# Function to handle the button click event
def on_show_button_click(list, nmb, n):
    table_name = list.get()
    if not table_name:
        mb.showerror('Błąd', 'Nie wybrano tabeli.')
        return
    if n == 'Numer apteki':
        mb.showerror('Błąd', 'Nie wybrano apteki.')
        return
    
    
    if table_name == 'informacje o receptach':query = queries[2]
    elif table_name == 'informacje o rezerwacjach':query = queries[3]
    elif table_name == 'informacje o pracownikach apteki':query = queries[4]
    elif table_name == 'informacje o stanie magazynu':query = queries[5]

    if nmb == 1:
        try:
            query = queries[nmb]
            query = query + ' ' + table_name
            
            column_names, records = fetch_data(query)
            table_view(column_names, records)
        except Exception as e:
            mb.showerror('Błąd', str(e))
    else:
        try:
            query = query.format(n=n)
            column_names, records = fetch_data(query)
            table_view(column_names, records)
        except Exception as e:
            mb.showerror('Błąd', str(e))


# Function to calculate the maximum width of the columns
def get_max_width(values):
    return max(len(str(value)) for value in values)


# Function to display the data in a table
def table_view(column_names, records):
    global tree
    if 'tree' in globals():
        tree.destroy()

    tree = ttk.Treeview(root, columns=column_names, show='headings')

    for col in column_names:
        col_width = get_max_width([row[column_names.index(col)] for row in records])
        tree.heading(col, text=col)
        tree.column(col, width=col_width, anchor='center')

    for row in records:
        tree.insert('', END, values=row)

    tree_scroll = ttk.Scrollbar(root, orient='vertical', command=tree.yview)
    tree.configure(yscrollcommand=tree_scroll.set)
    tree.grid(row=3, column=1, sticky='nsew')
    tree_scroll.grid(row=3, column=2, sticky='ns')

    root.grid_rowconfigure(4, weight=1)
    root.grid_columnconfigure(1, weight=1)


# Function to add a record to the database
def add(table_name):
    if not table_name:
        mb.showerror('Błąd', 'Nie wybrano tabeli.')
        return
     
    add_window = Toplevel()
    add_window.title(f'Dodaj rekord w {table_name}')
    frame = ttk.Frame(add_window)
    frame.pack(expand=True, fill='both')

    style = ttk.Style()
    style.theme_use(theme) 

    c = conn.cursor()
    c.execute(f'SELECT * FROM {table_name} WHERE FALSE')
    column_names = [desc[0] for desc in c.description][1:]
    c.close()

    entries = {}
    for i, col in enumerate(column_names):
        label = ttk.Label(frame, text=col)
        label.grid(row=i, column=0, padx=10, pady=10)
        
        entry = ttk.Entry(frame)
        entry.grid(row=i, column=1, padx=10, pady=10)
        entries[col] = entry

    def submit_record():
        try:
            columns = ', '.join(column_names)
            placeholders = ', '.join('%s' for _ in column_names)
            values = [entry.get() for entry in entries.values()]
            insert_query = f'INSERT INTO {table_name} ({columns}) VALUES ({placeholders})'

            c = conn.cursor()
            c.execute(insert_query, tuple(values))  
            conn.commit()
            add_window.destroy()  
        except psycopg2.Error as e:
            conn.rollback()  
            error_message = str(e).split('\n')[0]
            messagebox.showerror('Błąd dodawania do tabeli', error_message)
            add_window.destroy() 
        finally:
            c.close()

    submit_button = ttk.Button(frame, text='Dodaj', command=submit_record)
    submit_button.grid(row=len(column_names), column=1, pady=10)


# Function to update a record in the database
def update(table_name):
    if not table_name:
        mb.showerror('Błąd', 'Nie wybrano tabeli.')
        return
    
    update_window = Toplevel()
    update_window.title(f'Zmień rekord w tabeli {table_name}')
    frame = ttk.Frame(update_window)
    frame.pack(expand=True, fill='both')

    c = conn.cursor()
    c.execute(f'SELECT column_name FROM information_schema.columns WHERE table_name = %s AND ordinal_position = 1', (table_name,))
    primary_key_column = c.fetchone()[0]
    c.close()

    id_label = ttk.Label(frame, text=f'{primary_key_column}:')
    id_label.grid(row=0, column=0, padx=15, pady=10)
    id_entry = ttk.Entry(frame)
    id_entry.grid(row=0, column=1, padx=15, pady=10)

    update_frame = ttk.Frame(frame)
    update_frame.grid(row=1, column=0, columnspan=2, pady=10)

    def fetch_record():
        c = conn.cursor()
        try:
            c.execute(f'SELECT column_name FROM information_schema.columns WHERE table_name = %s AND ordinal_position = 1', (table_name,))
            primary_key_column = c.fetchone()[0]
            record_id = id_entry.get()

            c.execute(f'SELECT * FROM {table_name} WHERE {primary_key_column} = %s', (record_id,))
            record = c.fetchone()

            if record:
                create_update_fields(record, primary_key_column, record_id)
            else:
                mb.showerror('Błąd', 'Takie id nie istnieje')
        except psycopg2.Error as e:
            mb.showerror('Database Error', str(e))
        finally:
            c.close()

    def create_update_fields(record, primary_key_column, record_id):
        c = conn.cursor()
        c.execute(f'SELECT * FROM {table_name} WHERE FALSE')
        column_names = [desc[0] for desc in c.description][1:]  
        c.close()

        entries = {}
        for i, col in enumerate(column_names, start=1):
            label = ttk.Label(frame, text=col)
            label.grid(row=i, column=0, padx=10, pady=10)

            entry = ttk.Entry(frame)
            entry.grid(row=i, column=1, padx=10, pady=10)
            entry.insert(0, str(record[i]))
            entries[col] = entry

        def submit_changes():
            set_clause = ', '.join([f'{col} = %s' for col in column_names])
            values = [entry.get() for entry in entries.values()] + [record_id]
            update_query = f'UPDATE {table_name} SET {set_clause} WHERE {primary_key_column} = %s'
            
            c = conn.cursor()
            c.execute(update_query, values)
            conn.commit()
            c.close()
            update_window.destroy()

        submit_button = ttk.Button(frame, text='Zmień', command=submit_changes)
        submit_button.grid(row=0, column=2, padx=10,pady=10)

    fetch_button = ttk.Button(frame, text='Dalej', command=fetch_record)
    fetch_button.grid(row=0, column=2, padx=10, pady=10)


# Function to delete a record from the database
def delete(table_name):
    if not table_name:
        mb.showerror('Błąd', 'Nie wybrano tabeli.')
        return
    
    delete_window = Toplevel()
    delete_window.title(f'Usuń rekord z tabeli {table_name}')
    frame = ttk.Frame(delete_window)
    frame.pack(expand=True, fill='both')

    c = conn.cursor()
    c.execute(f'SELECT column_name FROM information_schema.columns WHERE table_name = %s AND ordinal_position = 1', (table_name,))
    primary_key_column = c.fetchone()[0]
    c.close()

    id_label = ttk.Label(frame, text=f'{primary_key_column} rekordu do usunięcia:')
    id_label.grid(row=0, column=0, padx=5, pady=10)
    id_entry = ttk.Entry(frame)
    id_entry.grid(row=0, column=1, padx=5, pady=10)

    def fetch_and_confirm_deletion():
        record_id = id_entry.get()
        try:
            c = conn.cursor()
            c.execute(f'SELECT * FROM {table_name} WHERE {primary_key_column} = %s', (record_id,))
            record = c.fetchone()
            if record:
                confirm = mb.askyesno('Potwierdź', f'Czy na pewno chcesz usunąć rekord:\n{record}?')
                if confirm:
                    delete_query = f'DELETE FROM {table_name} WHERE {primary_key_column} = %s'
                    c.execute(delete_query, (record_id,))
                    conn.commit()
                    mb.showinfo('Sukces', 'Rekord został usunięty.')
            else:
                mb.showerror('Błąd', 'Nie znaleziono rekordu.')
        except psycopg2.Error as e:
            mb.showerror('Błąd bazy danych', str(e))
        finally:
            c.close()
            delete_window.destroy()

    delete_button = ttk.Button(frame, text='Usuń', command=fetch_and_confirm_deletion)
    delete_button.grid(row=1, column=1, pady=10)


# Function to change the theme of the application
def set_theme(th):
    global theme
    root.set_theme(th)
    root.update_idletasks()
    theme = th


# Function to generate a report and save it to a file
def generate_report(r):
    c = conn.cursor()
    c.execute('SELECT apteka_id FROM apteki')
    pharmacies = c.fetchall()
    date = datetime.now().strftime('%Y-%m-%d')
    with open('raport_'+r+'_'+str(date)+'.txt', 'a') as text_file:
        for apteka_id in pharmacies:
            if r == 'recepty_zrealizowane': query = queries[2]
            elif r == 'informacje_o_rezerwacjach': query = queries[3]
            elif r == 'pracownicy_aptek': query = queries[4]
            elif r == 'podsumowanie_magazynów': query = queries[5]
            nr = str(apteka_id)[1]
            query = query.format(n=nr)
            print(query)
            c.execute(query, (apteka_id,))
            records = c.fetchall()
            
            text_file.write('Apteka nr '+str(nr)+' :\n')
            for row in records:
                line = ', '.join(map(str, row)) + '\n'
                text_file.write(line)
            text_file.write('\n')


# Function to reset the database to its initial state ( reset.sql )
def reset_base(): 
    c = conn.cursor()
    filepath = 'reset.sql'
    with open(filepath, 'r') as fd:
        sql_file = fd.read()

    sql_commands = sql_file.split('--')

    for command in sql_commands:
        try:
            if command.strip() != '':
                c.execute(command)
        except Exception as e:
            print("Command skipped: ", e)

    conn.commit()


# Lists of themes, raports, tables, and other data useful in the application
themes = [
    'adapta',
    'black',
    'breeze',
    'clearlooks',
    'elegance',
    'kroc',
    'plastik',
    'radiance',
    'ubuntu',
    'winxpblue',
    'xpnative'
    ]
raports = [
    'recepty_zrealizowane',
    'informacje_o_rezerwacjach',
    'pracownicy_aptek',
    'podsumowanie_magazynów'
    ]
tables = [
    'pracownicy', 
    'leki', 
    'pacjenci', 
    'apteki', 
    'pojazdy', 
    'rezerwacje', 
    'recepty',
    'magazyny'
    ]

nazwy_lekow = ['Apap', 'Ibuprom', 'Paracetamol', 'Amol','Aspiryna', 'Nurofen','Gripex', 'ACC', 'Neo-Angin', 'Cholinex', 'Acatar', 'Rutinoscorbin']

resets = ['Potwierdz reset']
views = [
    'informacje o receptach',
    'informacje o rezerwacjach',
    'informacje o pracownikach apteki',
    'informacje o stanie magazynu'
    ]

queries={   1:  '''SELECT * FROM''',
            2:  '''SELECT imie, nazwisko, pesel, kod_recepty, rachunek, lista_lekow as "lista lekow" 
                    FROM podsumowanie_recepty WHERE apteka_realizujaca={n}
                ''',
            3:  '''SELECT imie, nazwisko, marka, rejestracja, data_rozpoczecia, data_zakonczenia 
                    FROM podsumowanie_rezerwacji WHERE apteka_id={n}
                ''',
            4:  '''SELECT imie, nazwisko, plec, data_zatrudnienia, stanowisko 
                    FROM podsumowanie_pracownikow WHERE apteka_id={n}
                ''',
            5:  '''SELECT * FROM podsumowanie_magazynu WHERE numer_apteki={n}
                '''
        }



# GUI part of the application
menu = Menu(root)
root.config(menu=menu)

theme_menu = Menu(menu, tearoff=False)
menu.add_cascade(label='Style', menu=theme_menu)


for t in themes:
    theme_menu.add_command(label=t, command=lambda t=t: set_theme(t))

raports_menu = Menu(menu, tearoff=False)
menu.add_cascade(label='Raporciki', menu=raports_menu)


for r in raports:
    raports_menu.add_command(label=r, command=lambda r=r: generate_report(r))

reset_menu = Menu(menu, tearoff=False)
menu.add_cascade(label='Resetuj baze', menu=reset_menu)


for r in resets:
    reset_menu.add_command(label=r, command=lambda r=r: reset_base())

my_frame = ttk.LabelFrame(root)
my_frame.grid(row=2, column=1,pady=20,columnspan=2, sticky='NSWE')


f1 = ttk.Label(root, text='').grid(row=2, column=0,padx=5)
f2 = ttk.Label(root, text='').grid(row=2, column=5,padx=5)

add_label = ttk.Label(my_frame, text='Dodaj rekord do tabeli :')
add_label.grid(row=1, column=0, pady=10, padx=5)

add_list = ttk.Combobox(my_frame, values=tables, width=30)
add_list.grid(row=1, column=1, pady=10, padx=5)

add_button = ttk.Button(my_frame, text='Dalej', command=lambda:add(add_list.get()))
add_button.grid(row=1, column=5, pady=10, padx=5)


update_label = ttk.Label(my_frame, text='Zmien rekord w tabeli :')
update_label.grid(row=2, column=0, pady=10, padx=5)

update_list = ttk.Combobox(my_frame, values=tables, width=30)
update_list.grid(row=2, column=1, pady=10, padx=5)

update_button = ttk.Button(my_frame, text='Dalej', command=lambda:update(update_list.get()))
update_button.grid(row=2, column=5, pady=10, padx=5)


delete_label = ttk.Label(my_frame, text='Usuń rekord z tabeli :')
delete_label.grid(row=3, column=0, pady=10, padx=5)

delete_list = ttk.Combobox(my_frame, values=tables, width=30)
delete_list.grid(row=3, column=1, pady=10, padx=5)

delete_button = ttk.Button(my_frame, text='Dalej', command=lambda:delete(delete_list.get()))
delete_button.grid(row=3, column=5, pady=10, padx=5)


view_label = ttk.Label(my_frame, text='Pzydatne widoki :')
view_label.grid(row=5, column=0, pady=10, padx=5)

view_list = ttk.Combobox(my_frame, values=views, width=30) 
view_list.grid(row=5, column=1, pady=10, padx=5)
nr_list = ttk.Combobox(my_frame, values=[1,2,3,4], width=12) 
nr_list.grid(row=5, column=2, pady=10, sticky=W)
nr_list.set('Numer apteki')

view_button = ttk.Button(my_frame, text='Pokaż', command=lambda:on_show_button_click(view_list,0,nr_list.get()))
view_button.grid(row=5, column=5, pady=10, padx=30)


show_label = ttk.Label(my_frame, text='Podglad na tabelę :')
show_label.grid(row=6, column=0, pady=10, padx=5)

show_list = ttk.Combobox(my_frame, values=tables, width=30)
show_list.grid(row=6, column=1, pady=10, padx=5)

show_button = ttk.Button(my_frame, text='Pokaż', command=lambda:on_show_button_click(show_list,1,0))
show_button.grid(row=6, column=5, pady=10, padx=5)



root.grid_columnconfigure(1, weight=1)
root.grid_rowconfigure(2, weight=1)    

my_frame.grid_columnconfigure(0, weight=1) 
my_frame.grid_columnconfigure(1, weight=1) 

root.mainloop()



