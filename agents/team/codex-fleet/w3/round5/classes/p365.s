# n=5 model=out iset=I1 prefix14_class=365
mov S2, P3
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmp P2, P0
cmovge P3, P2
mov S1, P1
cmovg P2, P0
cmovg P0, P3
mov S0, P0
cmp P2, P1
cmovle S1, P2
cmovl P2, P1
cmp S2, P0
