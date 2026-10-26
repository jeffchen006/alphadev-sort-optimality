# n=5 model=out iset=I1 prefix14_class=13899
cmp P3, P0
mov S1, P1
cmovle S0, P3
cmovg S0, P0
cmovge P0, P3
cmp P2, S1
cmovg P1, P2
cmovg P2, S1
cmp P0, P1
cmovg S1, P1
cmovge P1, P0
cmovg P0, S1
cmp S0, P2
cmovle P1, S0
