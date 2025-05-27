import tkinter as tk
from tkinter import ttk
import psycopg2
from tkinter import messagebox

DB_NAME = "faculdade"
DB_USER = "postgres"
DB_PASSWORD = "univassouras"
DB_HOST = "localhost"

# Função para inserir dados do usuário na tabela users
def insert_user_data():
    nome = entry_nome.get()
    idade = entry_idade.get()
    curso = entry_curso.get()
    
    if nome and idade.isdigit() and curso:
        try:
            conn = psycopg2.connect(
                dbname= DB_NAME,
                user= DB_USER,
                password= DB_PASSWORD,
                host= DB_HOST
            )
            cur = conn.cursor()
            
            cur.execute("INSERT INTO alunos (nome, idade, curso) VALUES (%s, %s, %s)", (nome, int(idade), curso))
            
            conn.commit()
            
            messagebox.showinfo("Success", "User data inserted successfully")
        except psycopg2.Error as e:
            messagebox.showerror("Database Error", str(e))
        except Exception as e:
            messagebox.showerror("Error", str(e))
        finally:
            if conn:
                cur.close()
                conn.close()
    else:
        messagebox.showwarning("Input error", "Please enter valid user data")

# Função para inserir dados do funcionário na tabela funcionarios
def insert_funcionario_data():
    professor = entry_professor.get()
    disciplina = entry_disciplina.get()
    
    if professor and disciplina:
        try:
            conn = psycopg2.connect(
                dbname= DB_NAME,
                user= DB_USER,
                password= DB_PASSWORD,
                host= DB_HOST
            )
            cur = conn.cursor()
            
            cur.execute("INSERT INTO professores (nome, disciplina) VALUES (%s, %s)", (professor, disciplina))
            
            conn.commit()
            
            messagebox.showinfo("Success", "Funcionario data inserted successfully")
        except psycopg2.Error as e:
            messagebox.showerror("Database Error", str(e))
        except Exception as e:
            messagebox.showerror("Error", str(e))
        finally:
            if conn:
                cur.close()
                conn.close()
    else:
        messagebox.showwarning("Input error", "Please enter valid funcionario data")

# Função para buscar dados usando LEFT JOIN entre users e funcionarios
def fetch_data():
    try:
        conn = psycopg2.connect(
            dbname= DB_NAME,
            user= DB_USER,
            password= DB_PASSWORD,
            host= DB_HOST
        )
        cur = conn.cursor()
        
        cur.execute("SELECT alunos.id, alunos.nome, alunos.idade, alunos.curso, professores.id, professores.nome, professores.disciplina "
                    "FROM alunos LEFT JOIN professores ON professores.id = alunos.id")
        
        for row in tree.get_children():
            tree.delete(row)
        
        for row in cur.fetchall():
            tree.insert("", "end", values=row)
            
        messagebox.showinfo("Success", "Data fetched successfully")
    except psycopg2.Error as e:
        messagebox.showerror("Database Error", str(e))
    except Exception as e:
        messagebox.showerror("Error", str(e))
    finally:
        if conn:
            cur.close()
            conn.close()


root = tk.Tk()
root.title("Cadastro de Usuários e Funcionários")


tk.Label(root, text="Nome do Usuário").grid(row=0, column=0)
entry_nome = tk.Entry(root)
entry_nome.grid(row=0, column=1)

tk.Label(root, text="Idade do Usuário").grid(row=1, column=0)
entry_idade = tk.Entry(root)
entry_idade.grid(row=1, column=1)

tk.Label(root, text="Curso do Usuário").grid(row=2, column=0)
entry_curso = tk.Entry(root)
entry_curso.grid(row=2, column=1)


tk.Label(root, text="Nome do Professor").grid(row=3, column=0)
entry_professor = tk.Entry(root)
entry_professor.grid(row=3, column=1)

tk.Label(root, text="Disciplina do Professor").grid(row=4, column=0)
entry_disciplina = tk.Entry(root)
entry_disciplina.grid(row=4, column=1)

tk.Button(root, text="Cadastrar Dados de Usuário", command=insert_user_data).grid(row=5, columnspan=2)

tk.Button(root, text="Cadastrar Dados de Professor", command=insert_funcionario_data).grid(row=6, columnspan=2)

columns = ("ID do Usuário", "Nome do Usuário", "Idade", "Curso", "ID do Professor", "Professor", "Disciplina")
tree = ttk.Treeview(root, columns=columns, show="headings")
for col in columns:
    tree.heading(col, text=col)
tree.grid(row=7, column=0, columnspan=2, sticky='nsew')

# Botão para mostrar dados usando LEFT JOIN entre users e funcionarios
tk.Button(root, text="Mostrar Dados", command=fetch_data).grid(row=8, columnspan=2)

root.mainloop()
