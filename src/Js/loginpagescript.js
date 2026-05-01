

document.addEventListener("DOMContentLoaded", async function () {
    // If already logged in, skip login page
    await window.redirectIfLoggedIn();

    const loginForm = document.querySelector('.login-form'); 
    const emailInput = document.querySelector('input[type="email"]');
    const passwordInput = document.querySelector('input[type="password"]');
    const forgotLink = document.getElementById("forgotPasswordLink");

    forgotLink.addEventListener("click", async function (e) {
        e.preventDefault();

        const email = prompt("Enter your email for password reset:");

        if (!email) return;

        const { error } = await window.supabase.auth.resetPasswordForEmail(email, {
            redirectTo: "https://myllejar.github.io/resetPassword.html"
        });

        if (error) {
            alert("Error: " + error.message);
            return;
        }
        alert("Password reset email sent. Check your inbox and spam folder.");
    });

    function isValidEmail(email) {
        return /^\S+@\S+\.\S+$/.test(email);
    }

    loginForm.addEventListener('submit', async function(e) {
        e.preventDefault(); 

        const email = emailInput.value.trim();
        const password = passwordInput.value.trim();

        if (email === '') {
            alert('Please enter your email address.');
            emailInput.focus();
            return;
        }

        if (!isValidEmail(email)) {
            alert('Please enter a valid email address.');
            emailInput.focus();
            return;
        }

        if (password === '') {
            alert('Please enter your password.');
            passwordInput.focus();
            return;
        }

        console.log("Attempting logging in");

        const { data, error } = await window.supabase.auth.signInWithPassword({
            email,
            password
        });

        if (error) {
            console.error(error);
            alert("Login failed: " + error.message);
            return;
        }

        if (!data.session) {
            alert("Login succeeded, but no session was returned.");
            return;
        }

        window.location.href = "homepage.html";
    });
});