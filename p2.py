#!/usr/bin/python3
#Jack Liu
#jalliu
#112655156
#p2.py

from tkinter import *
from tkinter import messagebox


# Main window definition
root = Tk()
root.geometry("800x600")
root.title("Contact List")
root.configure(bg = "cyan")

# Constants
FIRST_NAME = 0
LAST_NAME = 1
STREET = 2
TOWN = 3
STATE = 4
ZIP = 5
PHONE = 6
EMAIL = 7

# Global variables
current_view = 1
contact_fields = dict()
contact_list = [{'fn' : 'Liara', 'ln' : 'T\'soni', 'str' : '113 Prothean Way', 'twn' : 'Sparta Base',
                 'st' : 'Mars', 'zip' : '11223', 'phn' : '555-229-0447', 'eml' : 'liara@mail.edu', 'uid' : '0'}, #Start at 0 because it feels right :)
                {'fn' : 'John', 'ln' : 'Shepard', 'str' : '91 Main Street', 'twn' : 'Los Angeles',
                 'st' : 'CA', 'zip' : '26774', 'phn' : '555-977-2231', 'eml' : 'js@mail.edu', 'uid' : '1'}, #also makes assigning unique_id simpler
                {'fn' : 'John', 'ln' : 'Doe', 'str' : '91 Main Street', 'twn' : 'Los Angeles',
                 'st' : 'CA', 'zip' : '26774', 'phn' : '555-977-2231', 'eml' : 'js@mail.edu', 'uid' : '2'},
                {'fn' : 'Jane', 'ln' : 'Shepard', 'str' : '111 Station Concourse', 'twn' : 'Terminus',
                 'st' : 'L3 Langrangian', 'zip' : '11008', 'phn' : '555-224-2442', 'eml' : 'bestshepard@mail.edu', 'uid' : '3'},
                {'fn' : 'Garrus', 'ln' : 'Vakarian', 'str' : '10 Turian Blvd.', 'twn' : 'Sector 7',
                 'st' : 'The Citadel', 'zip' : '77663', 'phn' : '555-854-3321', 'eml' : 'csecrocks@mail.edu', 'uid' : '4'},
                {'fn' : 'Garrus', 'ln' : 'Vakarian', 'str' : '10 Turian Blvd.', 'twn' : 'Sector 7',
                 'st' : 'The Citadel', 'zip' : '77663', 'phn' : '555-854-3321', 'eml' : 'csecrocks@mail.edu', 'uid' : '5'},
                {'fn' : 'Urdnot', 'ln' : 'Wrex', 'str' : '21 Ruins Ave.', 'twn' : 'The Ruins',
                 'st' : 'Tuchanka', 'zip' : '46654', 'phn' : '555-993-6442', 'eml' : 'wrexisbest@mail.edu', 'uid' : '6'}]
unique_id = len(contact_list)
search_txt = StringVar()
search_txt.set("First Name")
search_value = FIRST_NAME
remove_txt = StringVar()
remove_txt.set("First Name")
remove_value = FIRST_NAME

# Callback functions
def save_contact():
    global contact_list
    global unique_id
    contact_dict = dict()
    for field in contact_fields:
        contact_dict[field] = contact_fields[field].get()
    contact_dict['uid'] = str(unique_id)
    unique_id = unique_id + 1
    contact_list.append(contact_dict)
    for field in contact_fields:
        contact_fields[field].set("")
# end save_contact()

def clear_contact():
    for field in contact_fields:
        contact_fields[field].set("")
# end clear_contact()

def find_contact():
    query = search_str.get()
    results = []
    if search_value == FIRST_NAME:
        for c in contact_list:
            if c['fn'] == query:
                results.append(c)
    elif search_value == LAST_NAME:
        for c in contact_list:
            if c['ln'] == query:
                results.append(c)
    elif search_value == PHONE:
        for c in contact_list:
            if c['phn'] == query:
                results.append(c)
    elif search_value == EMAIL:
        for c in contact_list:
            if c['eml'] == query:
                results.append(c)
    #print(results)
    result_field.delete(1.0, END)
    for c in results:
        result_field.insert(END, stringify_contact(c)) 
# end find_contact()

def find_contact_2():
    query = remove_str.get()
    results = []
    if remove_value == FIRST_NAME:
        for c in contact_list:
            if c['fn'] == query:
                results.append(c)
    elif remove_value == LAST_NAME:
        for c in contact_list:
            if c['ln'] == query:
                results.append(c)
    elif remove_value == PHONE:
        for c in contact_list:
            if c['phn'] == query:
                results.append(c)
    elif remove_value == EMAIL:
        for c in contact_list:
            if c['eml'] == query:
                results.append(c)
    #print(results)
    result_field_2.delete('0','end')
    for c in results:
        result_field_2.insert('end',stringify_contact(c)) 
# end find_contact_2()


def remove_search_2():
######################parse out for unique id and remove from contact_list and updat4e messagebox showing##########################################################################################################################################
    sel = result_field_2.curselection()
    for index in sel[::-1]:
        for contact in contact_list:
            if(result_field_2.get(index).split(" ")[1]==contact['uid']):
                contact_list.remove(contact)
        messagebox.showinfo("Important", result_field_2.get(index).split(" ")[3] + " " + result_field_2.get(index).split(" ")[4] + " has been removed")
        result_field_2.delete(index)
        
        #contact_list.remove(result_field_2.get(index))
        #make a unique id for all contact and updat all funciton to account for it
    
# end remove_search_2()

def stringify_contact(c):
    s = "" #Added spaces after each segment for listBox clarity
    s += "UID: " + c['uid'] + " \n"
    s += "Name: " + c['fn'] + " " + c['ln'] + " \n"
    s += "Phone: " + c['phn'] + " \n"
    s += "Email: " + c['eml'] + " \n\n"
    return s
# end stringify_contact()

def clear_search():
    search_str.set("")
# end clear_contact_2()

def search_by_fn():
    #print("Search by FN")
    global search_value
    search_txt.set("First Name")
    search_value = FIRST_NAME
# end search_by_fn()

def search_by_ln():
    #print("Search by LN")
    global search_value
    search_txt.set("Last Name")
    search_value = LAST_NAME
# end search_by_ln()

def search_by_phn():
    #print("Search by PHN")
    global search_value
    search_txt.set("Phone Number")
    search_value = PHONE
# end search_by_phn()

def search_by_eml():
    #print("Search by EML")
    global search_value
    search_lbl = "Email"
    search_txt.set("Email")
    search_value = EMAIL
# end search_by_eml()


def clear_search_2():
    remove_str.set("")
# end clear_contact_2()

def search_by_fn_2():
    #print("Search by FN")
    global remove_value
    remove_txt.set("First Name")
    remove_value = FIRST_NAME
# end search_by_fn_2()

def search_by_ln_2():
    #print("Search by LN")
    global remove_value
    remove_txt.set("Last Name")
    remove_value = LAST_NAME
# end search_by_ln_2()

def search_by_phn_2():
    #print("Search by PHN")
    global remove_value
    remove_txt.set("Phone Number")
    remove_value = PHONE
# end search_by_phn_2()

def search_by_eml_2():
    #print("Search by EML")
    global remove_value
    remove_lbl = "Email"
    remove_txt.set("Email")
    remove_value = EMAIL
# end search_by_eml_2()

def change_view():
    global current_view
    if radio_var.get() == current_view:
        #print(radio_var.get(), current_view)
        pass
    elif radio_var.get() == 1:
        find_container_frame.pack_forget()
        remove_container_frame.pack_forget()
        current_view = 1
        build_add_view()
    elif radio_var.get() == 2:
        container_frame.pack_forget()
        remove_container_frame.pack_forget()
        current_view = 2
        build_find_view()
    elif radio_var.get() == 3:
        container_frame.pack_forget()
        find_container_frame.pack_forget()
        current_view = 3
        build_remove_view()
# end change_view()

# Widget Definitions
topspace_frame = Frame(root, height = 100, bg = "cyan")
midspace_frame = Frame(root, height = 40, bg = "cyan")

radio_frame = Frame(root, bg = "cyan")
radio_var = IntVar()
radio_lbl = Label(radio_frame, width = 16, anchor = W, text = "Select View:", bg = "cyan")
radio_add = Radiobutton(radio_frame, text = "Add contact", variable = radio_var,
                          value = 1, command = change_view, bg = "cyan")
radio_add.select()
radiomid = Frame(radio_frame, width = 32, bg = "cyan")
radio_find = Radiobutton(radio_frame, text = "Find contact", variable = radio_var,
                         value = 2, command = change_view, bg = "cyan")
radiomid2 = Frame(radio_frame, width = 32, bg = "cyan")
radio_remove = Radiobutton(radio_frame, text = "Remove contact", variable = radio_var,
                           value = 3, command = change_view, bg = "cyan")

# Add Contact Widgets
# These are the widgets that make up the add contact view
container_frame = Frame(root, bg = "cyan")

fname_frame = Frame(container_frame, bg = "cyan")
fname_lbl = Label(fname_frame, width = 16, anchor = W, text = "First Name:", bg = "cyan")
fname_str = StringVar()
contact_fields["fn"] = fname_str
fname_field = Entry(fname_frame, width = 32, textvariable = fname_str)

lname_frame = Frame(container_frame, bg = "cyan")
lname_lbl = Label(lname_frame, width = 16, anchor = W, text = "Last Name:", bg = "cyan")
lname_str = StringVar()
contact_fields["ln"] = lname_str
lname_field = Entry(lname_frame, width = 32, textvariable = lname_str)

street_frame = Frame(container_frame, bg = "cyan")
street_lbl = Label(street_frame, width = 16, anchor = W, text = "Street Address:", bg = "cyan")
street_str = StringVar()
contact_fields["str"] = street_str
street_field = Entry(street_frame, width = 32, textvariable = street_str)

town_frame = Frame(container_frame, bg = "cyan")
town_lbl = Label(town_frame, width = 16, anchor = W, text = "Town:", bg = "cyan")
town_str = StringVar()
contact_fields["twn"] = town_str
town_field = Entry(town_frame, width = 32, textvariable = town_str)

state_frame = Frame(container_frame, bg = "cyan")
state_lbl = Label(state_frame, width = 16, anchor = W, text = "State:", bg = "cyan")
state_str = StringVar()
contact_fields["st"] = state_str
state_field = Entry(state_frame, width = 32, textvariable = state_str)

zip_frame = Frame(container_frame, bg = "cyan")
zip_lbl = Label(zip_frame, width = 16, anchor = W, text = "Zip Code:", bg = "cyan")
zip_str = StringVar()
contact_fields["zip"] = zip_str
zip_field = Entry(zip_frame, width = 32, textvariable = zip_str)

phone_frame = Frame(container_frame, bg = "cyan")
phone_lbl = Label(phone_frame, width = 16, anchor = W, text = "Phone:", bg = "cyan")
phone_str = StringVar()
contact_fields["phn"] = phone_str
phone_field = Entry(phone_frame, width = 32, textvariable = phone_str)

email_frame = Frame(container_frame, bg = "cyan")
email_lbl = Label(email_frame, width = 16, anchor = W, text = "Email:", bg = "cyan")
email_str = StringVar()
contact_fields["eml"] = email_str
email_field = Entry(email_frame, width = 32, textvariable = email_str)

save_frame = Frame(container_frame, bg = "cyan")
save_btn = Button(save_frame, text = "SAVE", bg = "green", command = save_contact)
clear_btn = Button(save_frame, text = "CLEAR", bg = "red", command = clear_contact)

# Find Contact Widgets
# These are the widgets that make up the find contact view
find_container_frame = Frame(root, bg = "cyan")

search_frame = Frame(find_container_frame, bg = "cyan")
search_lbl = Label(search_frame, width = 16, anchor = W, text = "Search by:", bg = "cyan")

search_menu = Menubutton(search_frame, textvariable = search_txt, width = 16, bg = "cyan")
search_options = Menu(search_menu)
search_options.add_command(label = "First Name", command = search_by_fn)
search_options.add_command(label = "Last Name", command = search_by_ln)
search_options.add_command(label = "Phone", command = search_by_phn)
search_options.add_command(label = "Email", command = search_by_eml)
search_menu.configure(menu = search_options)

search_str = StringVar()
search_field = Entry(search_frame, width = 32, textvariable = search_str)

search_btn = Button(search_frame, text = "FIND", bg = "green", command = find_contact)
clear_search_btn = Button(search_frame, text = "CLEAR", bg = "red", command = clear_search)

result_frame = Frame(find_container_frame, bg = "cyan")
result_lbl = Label(result_frame, width = 16, anchor = W, text = "Results:", bg = "cyan")
result_field = Text(result_frame, width = 80, height = 25)

# Remove Contact Widgets
# These are the widgets that make up the remove contact view
remove_container_frame = Frame(root, bg = "cyan")

remove_frame = Frame(remove_container_frame, bg = "cyan")
remove_lbl = Label(remove_frame, width = 16, anchor = W, text = "Search by:", bg = "cyan")

remove_menu = Menubutton(remove_frame, textvariable = remove_txt, width = 16, bg = "cyan")
remove_options = Menu(remove_menu)
remove_options.add_command(label = "First Name", command = search_by_fn_2)
remove_options.add_command(label = "Last Name", command = search_by_ln_2)
remove_options.add_command(label = "Phone", command = search_by_phn_2)
remove_options.add_command(label = "Email", command = search_by_eml_2)
remove_menu.configure(menu = remove_options)

remove_str = StringVar()
remove_field = Entry(remove_frame, width = 32, textvariable = remove_str)

remove_btn = Button(remove_frame, text = "FIND", bg = "green", command = find_contact_2)
clear_remove_btn = Button(remove_frame, text = "CLEAR", bg = "red", command = clear_search_2)
remove_remove_btn = Button(remove_frame, text = "REMOVE", bg = "red3", command = remove_search_2)

result_frame_2 = Frame(remove_container_frame, bg = "cyan")
result_lbl_2 = Label(result_frame_2, width = 16, anchor = W, text = "Results:", bg = "cyan")
result_field_2 = Listbox(result_frame_2, width = 80, height = 25, selectmode = "multiple")

# Geometry Management
# Here we describe the layout of the GUI widgets
topspace_frame.pack()

radio_frame.pack()
radio_lbl.pack(side = LEFT)
radio_add.pack(side = LEFT)
radiomid.pack(side = LEFT)
radio_find.pack(side = LEFT)
radiomid2.pack(side = LEFT)
radio_remove.pack(side = LEFT)

midspace_frame.pack()
def build_add_view():
    container_frame.pack()

    fname_frame.pack()
    fname_lbl.pack(side = LEFT)
    fname_field.pack(side = LEFT)
    
    lname_frame.pack()
    lname_lbl.pack(side = LEFT)
    lname_field.pack(side = LEFT)
    
    street_frame.pack()
    street_lbl.pack(side = LEFT)
    street_field.pack(side = LEFT)
    
    town_frame.pack()
    town_lbl.pack(side = LEFT)
    town_field.pack(side = LEFT)
    
    state_frame.pack()
    state_lbl.pack(side = LEFT)
    state_field.pack(side = LEFT)
    
    zip_frame.pack()
    zip_lbl.pack(side = LEFT)
    zip_field.pack(side = LEFT)
    
    phone_frame.pack()
    phone_lbl.pack(side = LEFT)
    phone_field.pack(side = LEFT)

    email_frame.pack()
    email_lbl.pack(side = LEFT)
    email_field.pack(side = LEFT)
    
    save_frame.pack()
    save_btn.pack(side = LEFT)
    clear_btn.pack(side = LEFT)
# end build_add_view()

def build_find_view():
    find_container_frame.pack()

    search_frame.pack()
    search_lbl.pack(side = LEFT)
    search_menu.pack(side = LEFT)
    search_field.pack(side = LEFT)
    search_btn.pack(side = LEFT)
    clear_search_btn.pack(side = LEFT)

    result_frame.pack()
    result_lbl.pack(side = LEFT)
    result_field.pack(side = LEFT)
# end build_find_view()

def build_remove_view():
    remove_container_frame.pack()

    remove_frame.pack()
    remove_lbl.pack(side = LEFT)
    remove_menu.pack(side = LEFT)
    remove_field.pack(side = LEFT)
    remove_btn.pack(side = LEFT)
    clear_remove_btn.pack(side = LEFT)
    remove_remove_btn.pack(side = LEFT)

    result_frame_2.pack()
    result_lbl_2.pack(side = LEFT)
    result_field_2.pack(side = LEFT)
# end build_remove_view()



build_add_view()

root.mainloop()
