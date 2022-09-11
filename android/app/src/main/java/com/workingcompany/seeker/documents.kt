package com.workingcompany.seeker

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.widget.*
import com.firebase.ui.auth.AuthUI
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.safetynet.SafetyNetAppCheckProviderFactory
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.ktx.storage
import com.google.firebase.storage.ktx.component1
import com.google.firebase.storage.ktx.component2
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.ktx.firestore
import kotlinx.coroutines.*
import java.io.File
import java.io.IOException
import java.net.URL
import com.workingcompany.seeker.MainActivity.Companion.email

class documents : AppCompatActivity() {
    val AUTH_REQUEST_CODE = 1234
    lateinit var firebaseAuth: FirebaseAuth
    lateinit var  listener: FirebaseAuth.AuthStateListener
    lateinit var providers:List<AuthUI.IdpConfig>
    lateinit var storage: FirebaseStorage
    var docslist = arrayListOf<String>()
    val TAG = "MyActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        setContentView(R.layout.activity_documents)
        var email: String = email
        FirebaseApp.initializeApp(/*context=*/this)
        val firebaseAppCheck = FirebaseAppCheck.getInstance()
        firebaseAppCheck.installAppCheckProviderFactory(
            SafetyNetAppCheckProviderFactory.getInstance()
        )
        val db = Firebase.firestore

        var adapter = ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, docslist)
        val listView: ListView = findViewById(R.id.listView)
        val docRef = db.collection("test").document(email)
        val textView3: TextView = findViewById(R.id.textView3)
        docRef.get()
            .addOnSuccessListener { document ->
                if (document != null) {
                    Log.i(TAG, "DocumentSnapshot data: ${document.data}")
                    document.data?.forEach { (key,value) ->
                        docslist.add(value.toString())
                        listView.adapter = adapter
                        adapter.notifyDataSetChanged()
                    }
                }
            }
            .addOnFailureListener { exception ->
                Log.d(TAG, "get failed with ", exception)
            }
        storage = Firebase.storage
        val listRef = storage.reference.child("documents/")
        Log.i("MyActivity", "email: $email")
        /*listRef.listAll()
            .addOnSuccessListener { (items, prefixes) ->
                prefixes.forEach { prefix ->
                    // All the prefixes under listRef.
                    // You may call listAll() recursively on them.
                }

                items.forEach { item ->
                    docslist.add(item.toString().split("documents/", ".")[3])
                    Log.i("MyActivity", docslist.toString())
                    listView.adapter = adapter
                    adapter.notifyDataSetChanged()
                }
            }
            .addOnFailureListener {
                // Uh-oh, an error occurred!
            } */


        listView.setOnItemClickListener(){ parent, view, position, id ->

            var islandRef = listRef.child("${docslist[position]}")
            val TEN_MEGABYTE: Long = 10 * 1024 * 1024
            val url = listRef.child("${docslist[position]}").downloadUrl
            Log.i("MyActivity", url.toString())
            listRef.child("${docslist[position]}").downloadUrl.addOnSuccessListener {
                Log.i("MyActivity", it.toString())
                val frame: FrameLayout = findViewById(R.id.imageFrame)
                val docView: ImageView = findViewById(R.id.docview)
                val close: Button = findViewById(R.id.close)
                val listView: ListView = findViewById(R.id.listView)
                listView.visibility = View.INVISIBLE
                frame.visibility = View.VISIBLE
                val url = URL(it.toString())
                urlToImageView(docView,url)
                Toast.makeText(this, "Loading... :)", Toast.LENGTH_LONG).show()
                docView.visibility = View.VISIBLE

                close.visibility = View.VISIBLE

                close.setOnClickListener(){
                    docView.visibility = View.GONE
                    frame.visibility = View.GONE
                    close.visibility = View.GONE
                    listView.visibility = View.VISIBLE
                }
            }.addOnFailureListener {
                // Handle any errors
            }
        }

    }

    private fun urlToImageView(imageView:ImageView,urlImage:URL){
        // Async task to get bitmap from url
        val result: Deferred<Bitmap?> = GlobalScope.async {
            try {
                BitmapFactory.decodeStream(urlImage.openStream())
            }catch (e: IOException){
                null
            }
        }
        GlobalScope.launch(Dispatchers.Main) {
            // Show bitmap on image view when available
            imageView.setImageBitmap(result.await())
        }
    }

        fun goBack(view: View){
        val intent = Intent(this, MainActivity::class.java).apply{}
        startActivity(intent)
    }
}