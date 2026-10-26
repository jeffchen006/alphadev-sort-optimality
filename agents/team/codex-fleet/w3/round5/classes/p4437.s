# n=5 model=out iset=I1 prefix14_class=4437
mov S1, P3
cmp P1, P3
cmovg P3, P1
cmovg P1, S1
mov S0, P2
cmp P2, P0
cmovle S0, P0
mov S2, P3
cmovg P2, P0
cmp S2, S0
cmovge P3, S0
cmovle S2, S0
mov S2, P1
mov S1, P3
