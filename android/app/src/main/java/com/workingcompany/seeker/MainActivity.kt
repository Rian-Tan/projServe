package com.workingcompany.seeker

import androidx.appcompat.app.AppCompatActivity
import android.content.Intent
import android.net.Uri
import android.nfc.Tag
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.core.view.isVisible
import com.firebase.ui.auth.AuthUI
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.safetynet.SafetyNetAppCheckProviderFactory
import com.google.firebase.auth.AdditionalUserInfo
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.ktx.storage
import com.google.firebase.storage.ktx.component1
import com.google.firebase.storage.ktx.component2
import java.io.File


class MainActivity : AppCompatActivity() {
    companion object {
        var email = "test"
    }
    val AUTH_REQUEST_CODE = 1234
    lateinit var firebaseAuth: FirebaseAuth
    lateinit var  listener: FirebaseAuth.AuthStateListener
    lateinit var providers:List<AuthUI.IdpConfig>
    lateinit var storage: FirebaseStorage
    val TAG = "MyActivity"


    override fun onStart() {
        super.onStart()
        firebaseAuth.addAuthStateListener(listener)
    }

    override fun onStop() {
        if(listener != null){
            firebaseAuth.removeAuthStateListener(listener)
        }
        super.onStop()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        init()
        storage = Firebase.storage
    }

    private fun init() {

        providers = arrayListOf(
            AuthUI.IdpConfig.GoogleBuilder().build(),
        )
        firebaseAuth = FirebaseAuth.getInstance()
        listener = FirebaseAuth.AuthStateListener { p0 ->
            val user = p0.currentUser
            if(user != null){
                Toast.makeText(this@MainActivity, "signed in", Toast.LENGTH_SHORT).show()
                val button2: Button = findViewById(R.id.button2)
                val storageRef = storage.reference
                val db = Firebase.firestore
                Log.i("MyActivity", user.email.toString())  //works
                email = user.email.toString()

                val docRef = db.collection("test").document("${user.email}")
                docRef.get()
                    .addOnSuccessListener { document ->
                        if (document != null) {
                            Log.i(TAG, "DocumentSnapshot data: ${document.data}")
                            Log.i(TAG, "${user.email}")
                            if (document.data == null){
                                val docs = hashMapOf(
                                    "1" to "",
                                    "2" to "",
                                    "3" to "",
                                    "4" to "",
                                    "5" to "",
                                    "6" to "",
                                    "7" to "",
                                    "8" to "",
                                )
                                db.collection("test").document("${user.email}")
                                    .set(docs)
                                    .addOnSuccessListener { Log.i(TAG, "DocumentSnapshot successfully written!") }
                                    .addOnFailureListener { e -> Log.w(TAG, "Error writing document", e) }
                            }
                            else{
                                Log.i(TAG, "document alr exists")
                            }
                        } else {
                            Log.i(TAG, "No such document")
                        }
                    }
                    .addOnFailureListener { exception ->
                        Log.d(TAG, "get failed with ", exception)
                    }
                val documentsRef = storageRef.child("documents/" + user.email)
                button2.visibility = View.VISIBLE


            } else{
                startActivityForResult(AuthUI.getInstance()
                    .createSignInIntentBuilder()
                    .setAvailableProviders(providers)
                    .build(),AUTH_REQUEST_CODE)
            }
        }
    }

    fun signOut(view: View) {
            AuthUI.getInstance()
                .signOut(this)
                .addOnCompleteListener {
                    // ...
                }
            Toast.makeText(this@MainActivity, "signed out", Toast.LENGTH_SHORT).show()
            val button2: Button = findViewById(R.id.button2)
            button2.visibility = View.INVISIBLE
        }

    fun gotoDocuments(view: View) {
        val intent = Intent(this, documents::class.java).apply{}
        startActivity(intent)
    }


}