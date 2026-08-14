import { useContext, useState } from 'react'
import { GlobalStoreContext } from '../store'
import AuthContext from '../auth';
import Box from '@mui/material/Box';
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';
import IconButton from '@mui/material/IconButton';
import ListItem from '@mui/material/ListItem';
import TextField from '@mui/material/TextField';
import ThumbUpOutlinedIcon from '@mui/icons-material/ThumbUpOutlined';
import ThumbDownOutlinedIcon from '@mui/icons-material/ThumbDownOutlined';
import ThumbUpIcon from '@mui/icons-material/ThumbUp';
import ThumbDownIcon from '@mui/icons-material/ThumbDown';

/*
    This is a card in our list of top 5 lists. It lets select
    a list for editing and it has controls for changing its 
    name or deleting it.
    
    @author McKilla Gorilla
*/
function ListCard(props) {
    const { auth } = useContext(AuthContext);
    const { store } = useContext(GlobalStoreContext);
    const [editActive, setEditActive] = useState(false);
    const [text, setText] = useState("");
    const { idNamePair, selected } = props;

    function handleLoadList(event, id) {
        console.log("handleLoadList for " + id);
        if (!event.target.disabled) {
            let _id = event.target.id;
            if (_id.indexOf('list-card-text-') >= 0)
                _id = ("" + _id).substring("list-card-text-".length);

            console.log("load " + event.target.id);

            // CHANGE THE CURRENT LIST
            store.setCurrentList(id);
        }
    }

    function handleToggleEdit(event) {
        event.stopPropagation();
        toggleEdit();
    }

    function toggleEdit() {
        let newActive = !editActive;
        if (newActive) {
            store.setIsListNameEditActive();
        }
        setEditActive(newActive);
    }

    async function handleDeleteList(event, id) {
        event.stopPropagation();
        let _id = event.target.id;
        _id = ("" + _id).substring("delete-list-".length);
        store.markListForDeletion(id);
    }

    function handleKeyPress(event) {
        if (event.code === "Enter") {
            let id = event.target.id.substring("list-".length);
            store.changeListName(id, text);
            toggleEdit();
        }
    }
    function handleUpdateText(event) {
        setText(event.target.value);
    }
    let upvoted = false;
    let downvoted = false;
    function handleUpvote(event){
        event.stopPropagation();
        if(downvoted){
            downvoted=false;
        }
        upvoted=!upvoted;
        console.log("upvote happens here; don't show total likes and dislikes until you open the list to avoid bias; it should also toggle to a different button, but doesn't work");
    }
    function handleDownvote(event){
        event.stopPropagation();
        if(upvoted){
            upvoted=false;
        }
        downvoted=!downvoted;
        console.log("downvote happens here; don't show total likes and dislikes until you open the list to avoid bias; it should also toggle to a different button, but doesn't work");
    }

    let selectClass = "unselected-list-card";
    if (selected) {
        selectClass = "selected-list-card";
    }
    let cardStatus = false;
    if (store.isListNameEditActive) {
        cardStatus = true;
    }
    let upvoteIcon = <ThumbUpOutlinedIcon onClick={handleUpvote} sx={{ p: 1,fontSize:'48pt' }}></ThumbUpOutlinedIcon>;
    if(upvoted){
         upvoteIcon = <ThumbUpIcon onClick={handleUpvote} sx={{ p: 1,fontSize:'48pt' }}></ThumbUpIcon>;
    }
    let downvoteIcon = <ThumbDownOutlinedIcon onClick={handleDownvote} sx={{ p: 1,fontSize:'48pt' }}></ThumbDownOutlinedIcon>;
    if(downvoted){
         downvoteIcon = <ThumbDownIcon onClick={handleDownvote} sx={{ p: 1,fontSize:'48pt' }}></ThumbDownIcon>;
    }
    let cardElement =
        <ListItem
            id={idNamePair._id}
            key={idNamePair._id}
            sx={{ marginTop: '15px', display: 'flex', p: 1 }}
            style={{ width: '100%' }}
            button
            onClick={(event) => {
                handleLoadList(event, idNamePair._id)
            }
            }
            style={{
                fontSize: '48pt'
            }}
        >
                <Box sx={{ p: 1, flexGrow: 1 }}>
                    {idNamePair.name}
                    <Box style= {{fontSize:'12pt'}} sx={{ p: 1, flexGrow: 1 }}>
                        {auth.getUser()}
                    </Box>
                </Box>

                
                <IconButton aria-label='edit'>
                    {upvoteIcon}
                </IconButton>
                <IconButton aria-label='edit'>
                    {downvoteIcon}
                </IconButton>
                
                <Box sx={{ p: 1 }}>
                    <IconButton onClick={handleToggleEdit} aria-label='edit'>
                        <EditIcon style={{fontSize:'48pt'}} />
                    </IconButton>
                </Box>
                <Box sx={{ p: 1 }}>
                    <IconButton onClick={(event) => {
                        handleDeleteList(event, idNamePair._id)
                    }} aria-label='delete'>
                        <DeleteIcon style={{fontSize:'48pt'}} />
                    </IconButton>
                </Box>
        </ListItem>

    if (editActive) {
        cardElement =
            <TextField
                margin="normal"
                required
                fullWidth
                id={"list-" + idNamePair._id}
                label="Top 5 List Name"
                name="name"
                autoComplete="Top 5 List Name"
                className='list-card'
                onKeyPress={handleKeyPress}
                onChange={handleUpdateText}
                defaultValue={idNamePair.name}
                inputProps={{style: {fontSize: 48}}}
                InputLabelProps={{style: {fontSize: 24}}}
                autoFocus
            />
    }
    return (
        cardElement
    );
}

export default ListCard;