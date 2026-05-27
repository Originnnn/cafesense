import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyAw1T_GG7Qo3XOfi6OLDhGIb74WPtPEP1k",
  authDomain: "cafesense-511b1.firebaseapp.com",
  projectId: "cafesense-511b1",
  storageBucket: "cafesense-511b1.firebasestorage.app",
  messagingSenderId: "70666178323",
  appId: "1:70666178323:web:6f2b0af1d58ee9b1ed14e6",
  measurementId: "G-3JY766KWSH"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
export const auth = getAuth(app);
