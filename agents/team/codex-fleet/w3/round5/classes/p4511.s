# n=5 model=out iset=I1 prefix14_class=4511
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovle S0, P3
mov P3, P2
cmp P2, P0
cmovle P3, P0
cmovg P2, P0
mov P0, P3
cmp P3, S0
cmovg P0, S0
cmovg S0, P3
cmp P2, P1
cmovge P3, P1
