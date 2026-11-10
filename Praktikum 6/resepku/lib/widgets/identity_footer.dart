import 'package:flutter/material.dart'; 
  
// GANTI dengan NIM dan nama lengkap Kalian sendiri 
const String kNim = '2411532013'; 
const String kNama = 'Fadil Insanus Siddik'; 
  
class IdentityFooter extends StatelessWidget { 
  const IdentityFooter({super.key, required this.child}); 
  
  final Widget child; 
  
  @override 
  Widget build(BuildContext context) { 
    return Column( 
      children: [ 
        Expanded( 
          // ruang aman bawah sudah diurus footer, jadi tidak dihitung dua kali 
          child: MediaQuery.removePadding( 
            context: context, 
            removeBottom: true, 
            child: child, 
          ), 
        ), 
        Material( 
          color: Colors.black87, 
          child: SafeArea( 
            top: false, 
            child: SizedBox( 
              width: double.infinity, 
              child: Padding( 
                padding: const EdgeInsets.symmetric(vertical: 6), 
                child: Text( 
                  '$kNim  •  $kNama', 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(color: Colors.white, fontSize: 12), 
                ), 
              ), 
            ), 
          ), 
        ), 
      ], 
    ); 
  } 
} 