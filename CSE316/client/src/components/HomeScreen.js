import React, { useContext, useEffect, useState } from 'react'
import { GlobalStoreContext } from '../store'
import ListCard from './ListCard.js'
import MUIDeleteModal from './MUIDeleteModal'

import AddIcon from '@mui/icons-material/Add';
import Fab from '@mui/material/Fab'
import List from '@mui/material/List';
import Typography from '@mui/material/Typography';
import HomeOutlinedIcon from '@mui/icons-material/HomeOutlined';
import GroupsOutlinedIcon from '@mui/icons-material/GroupsOutlined';
import PersonOutlineOutlinedIcon from '@mui/icons-material/PersonOutlineOutlined';
import FunctionsIcon from '@mui/icons-material/Functions';
import SortIcon from '@mui/icons-material/Sort';
import TextField from '@mui/material/TextField';
import Menu from '@mui/material/Menu';
import MenuItem from '@mui/material/MenuItem';
import IconButton from '@mui/material/IconButton';

/*
    This React component lists all the top5 lists in the UI.
    
    @author McKilla Gorilla
*/
const HomeScreen = () => {
    const { store } = useContext(GlobalStoreContext);
    const [anchorE2, setAnchorE2] = useState(null);
    const isMenuOpen = Boolean(anchorE2);

    const handleProfileMenuOpen = (event) => {
        setAnchorE2(event.currentTarget);
        console.log("open menu; doesn't work rn");
        console.log("Publish Date(Newest)\nPublish Date(Oldest)\nViews\nLikes\nDislikes");
    };

    const handleMenuClose = () => {
        setAnchorE2(null);
        console.log("close menu");
    };

    const menuId = 'primary-search-account-menu';
    const loggedInMenu =
        <Menu
            anchorE2={anchorE2}
            anchorOrigin={{
                vertical: 'top',
                horizontal: 'right',
            }}
            id={menuId}
            keepMounted
            transformOrigin={{
                vertical: 'top',
                horizontal: 'right',
            }}
            open={isMenuOpen}
            onClose={handleMenuClose}
        >
            <MenuItem>Hi</MenuItem>
        </Menu>;
let menu = loggedInMenu;

    useEffect(() => {
        store.loadIdNamePairs();
    }, []);

    function handleCreateNewList() {
        store.createNewList();
    }
    let listCard = "";


function ownList(event){
    let bar = document.getElementById("outlined-basic");
    console.log("Searching your lists for - " + bar.value);
    console.log("Here, we would update store for search criteria, allowing Workspace Screen to filter out lists that don't match")
}
function allList(event){
    let bar = document.getElementById("outlined-basic");
    console.log("Searching ALL lists for - " + bar.value);
    console.log("Here, we would update store for search criteria, AND send a different request to the DB\n\
    await Top5List.find({ ownerEmail: email }, (err, top5Lists) => {\n\
    await Top5List.find({ ownerEmail: { '$exists': true } }, (err, top5Lists) => {");

}
function userList(event){
    let bar = document.getElementById("outlined-basic");
    console.log("Searching for lists with the user - " + bar.value);
    console.log("Here, we would update store for search2 criteria, allowing Workspace Screen to filter out by users")

}
function aggregateList(event){
    let bar = document.getElementById("outlined-basic");
    console.log("Searching aggregate lists for - " + bar.value);
    console.log("Here, we would update store for search criteria, and also let them know we wish to access the aggregate, where we would form the aggregate on demand\n\
    This isn't the most efficient way, especially in larger databases but it works well in small scale.")
}

    if (store) {
        listCard = 
            <List sx={{ width: '90%', left: '5%', bgcolor: 'background.paper' }}>
            {
                store.idNamePairs.map((pair) => (
                    <ListCard
                        key={pair._id}
                        idNamePair={pair}
                        selected={false}
                    />
                ))
            }
            </List>;
    }
    return (
        <div id="top5-list-selector">

            <div id="list-selector-heading">
            <Fab 
                color="primary" 
                aria-label="add"
                id="add-list-button"
                onClick={handleCreateNewList}
            >
                <AddIcon />
            </Fab>
                <Typography variant="h2">Your Lists</Typography>
            </div>
            <IconButton><HomeOutlinedIcon onClick={ownList} style={{width:50, height: 50}}></HomeOutlinedIcon></IconButton>
            <IconButton><GroupsOutlinedIcon onClick={allList} style={{width:50, height: 50}}></GroupsOutlinedIcon></IconButton>
            <IconButton><PersonOutlineOutlinedIcon onClick={userList} style={{width:50, height: 50}}></PersonOutlineOutlinedIcon></IconButton>
            <IconButton><FunctionsIcon onClick={aggregateList} style={{width:50, height: 50}}></FunctionsIcon></IconButton>
            <TextField style ={{width: '25%', backgroundColor: 'white'}} id="outlined-basic" label="Search" variant="outlined" />

            <span id="sort-by">Sort By</span>
            <IconButton id="sort-icon"
                aria-controls={menuId}
                aria-haspopup="true"
                onClick={handleProfileMenuOpen}
            >
                <SortIcon style={{width:50, height: 50}}>
                    { menu }
                </SortIcon>
            </IconButton>


            <div id="list-selector-list">
                {
                    listCard
                }
                <MUIDeleteModal />
            </div>
        </div>)
}

export default HomeScreen;