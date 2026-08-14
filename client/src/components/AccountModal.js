import Modal from '@mui/material/Modal';
import Alert from '@mui/material/Alert';
import Button from '@mui/material/Button';
import Box from '@mui/material/Box';
import { useContext } from 'react'
import { GlobalStoreContext } from '../store'
import { Typography } from '@mui/material'

const style = {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    width: 400,
    bgcolor: 'background.paper',
    border: '2px solid #000',
    boxShadow: 24,
    p: 4,
};
function AccountModal() {
    const { store } = useContext(GlobalStoreContext);
    const handleClose = () => store.setModalMessage(null);
    let text ="";
    if (store.currentList)
        text = store.currentList.name;
    return (
        <Modal
            open={store.modalMessage!==null}
            onClose={handleClose}
            aria-labelledby="modal-modal-title"
            aria-describedby="modal-modal-description"
        >
        <Box sx={style}>
        <Alert severity="warning">{store.modalMessage}</Alert>
        <Button variant="outlined" onClick={handleClose}>I understand</Button>
        </Box>
        </Modal>
    );
}
export default AccountModal; 