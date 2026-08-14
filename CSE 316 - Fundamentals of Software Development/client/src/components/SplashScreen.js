import Button from '@mui/material/Button';
import { Link } from 'react-router-dom'

export default function SplashScreen() {
    return (
        <div id="splash-screen">
            <div id = "title">The Top 5 Lister</div>
            <div class = "grid">
                <div id = "description">The Top 5 Lister Application allows you to list and display your personal top five favorite games, movies, or even Pink Floyd songs! You can see your friend's lists and even see the most popular items in any given category!</div>
                <Button component={Link} to="/register" variant="contained" id = "create">Create Account</Button>
                <Button component={Link} to="/login" variant="contained" id = "login">Login</Button>
                <Button variant="contained" id = "guest">Continue as Guest</Button> {/* TODO impleemnt continue as guest feature*/}
            </div>
            <div id = "credits"> Developed by Jack Liu</div>
        </div>
    )
}