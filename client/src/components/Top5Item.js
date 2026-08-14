import { React, useContext, useState } from "react";
import { GlobalStoreContext } from '../store'
import Box from '@mui/material/Box';
import EditIcon from '@mui/icons-material/Edit';
import IconButton from '@mui/material/IconButton';
import ListItem from '@mui/material/ListItem';
import TextField from '@mui/material/TextField';
/*
    This React component represents a single item in our
    Top 5 List, which can be edited or moved around.
    
    @author McKilla Gorilla
*/
function Top5Item(props) {
    const { store } = useContext(GlobalStoreContext);
    const [editActive, setEditActive] = useState(false);
    const [text, setText] = useState("");


    function handleKeyPress(event) {
        if (event.code === "Enter") {
            let index = event.target.id.substring("list-".length);
            let text = event.target.value;
            store.addUpdateItemTransaction(index-1, text);
            toggleEdit();
        }
    }

    function handleToggleEdit(event) {
        event.stopPropagation();
        toggleEdit();
    }

    function handleUpdateText(event) {
        setText(event.target.value);
    }

    function toggleEdit() {
        let newActive = !editActive;
        if (newActive) {
            store.setIsItemEditActive();
        }
        setEditActive(newActive);
    }

    let editStatus = false;
    if (store.isItemEditActive) {
        editStatus = true;
    }
    let { index } = props;

    let itemClass = "top5-item";

    let cardElement =
            <ListItem
                id={'item-' + (index+1)}
                className={itemClass}
                sx={{ display: 'flex', p: 1 }}
                style={{ width: '100%' }}
                style={{
                    fontSize: '48pt'
                }}
            >
            <Box sx={{ p: 1 }}>
                <IconButton onClick={handleToggleEdit} aria-label='edit'>
                    <EditIcon style={{fontSize:'48pt'}}  />
                </IconButton>
            </Box>
                <Box sx={{ p: 1, flexGrow: 1 }}>{props.text}</Box>
            </ListItem>

    if (editActive) {
        cardElement =    
            <TextField
                margin="normal"
                required
                fullWidth
                id={"item-" + (index+1)}
                label={"Item #" + (index+1)}
                name="item"
                autoComplete="Top 5 List Item"
                className='top5-item'
                onKeyPress={handleKeyPress}
                onChange={handleUpdateText}
                defaultValue={props.text}
                inputProps={{style: {fontSize: 48}}}
                InputLabelProps={{style: {fontSize: 24}}}
                autoFocus
            />
    }
    return (
        cardElement
    );
}

export default Top5Item;