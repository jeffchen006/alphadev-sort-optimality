# n=5 model=out iset=I1 prefix14_class=12263
cmp P1, P0
mov S0, P0
cmovg P0, P1
cmovle S0, P1
cmp P3, P2
cmovge P1, P2
cmovg P2, P3
mov S1, S0
cmovge P3, P1
cmp S0, P3
cmovle S0, P3
cmovg S1, P3
mov S1, P2
mov P3, S0
