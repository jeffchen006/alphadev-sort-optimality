# n=5 model=out iset=I1 prefix14_class=561
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P3, P2
mov S0, P3
cmovg P3, P2
cmovle S0, P2
mov P2, P0
cmp P3, P0
cmovge P0, P3
cmovle P2, P3
mov P3, S0
cmp P1, S0
