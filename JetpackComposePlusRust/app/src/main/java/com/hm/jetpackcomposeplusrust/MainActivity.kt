package com.hm.jetpackcomposeplusrust

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.hm.jetpackcomposeplusrust.ui.theme.JetpackComposePlusRustTheme


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            JetpackComposePlusRustTheme {
                val scope = rememberCoroutineScope()
                val snackbarHostState = remember { SnackbarHostState() }
                Scaffold(
                    snackbarHost = {
                        SnackbarHost(hostState = snackbarHostState)
                    },
                ) { innerPadding ->
                    Box(modifier = Modifier.fillMaxSize()) {
                        Column(
                            modifier = Modifier.fillMaxSize(),
                            horizontalAlignment = Alignment.CenterHorizontally,
                            verticalArrangement = Arrangement.Center
                        ) {
                            Greeting(
                                modifier = Modifier
                                    .padding(innerPadding)
                                    .align(Alignment.CenterHorizontally)
                            )
                            AddTwoNumbers(
                                modifier = Modifier
                                    .padding(innerPadding)
                                    .align(Alignment.CenterHorizontally)
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun Greeting(modifier: Modifier = Modifier) {
    val greet = NativeLib.greet()
    Text(
        text = greet, modifier = modifier
    )
}

@Composable
fun AddTwoNumbers(modifier: Modifier = Modifier) {
    val left = remember { mutableStateOf("") }
    val right = remember { mutableStateOf("") }
    val result = remember { mutableStateOf<Long>(0) }

    Row {
        TextField(
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            value = left.value,
            onValueChange = {
                left.value = it
            },
            label = { Text("Left") },
            modifier = modifier
                .padding(8.dp)
                .weight(1f, true)
        )
        TextField(
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
            value = right.value,
            onValueChange = {
                right.value = it
            },
            label = { Text("Right") },
            modifier = modifier
                .padding(8.dp)
                .weight(1f, true)
        )
        Button(
            onClick = {
                val leftValue = left.value.toLongOrNull() ?: 0L
                val rightValue = right.value.toLongOrNull() ?: 0L
                result.value = NativeLib.add(leftValue, rightValue)
            }, modifier = modifier
                .padding(8.dp)
                .width(100.dp)
        ) {
            Text(text = "=")
        }
        Text(
            text = "${result.value}",
            modifier = modifier
                .padding(8.dp)
                .weight(1f, true)
        )
    }
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    JetpackComposePlusRustTheme {
        Greeting()
    }
}