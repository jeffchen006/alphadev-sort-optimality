# n=5 model=out iset=I1 prefix14_class=7327
mov S2, P2
cmp P3, P2
cmovle S2, P3
cmovg P2, P3
cmp P0, P1
mov S1, P1
cmovle S1, P0
mov S0, S2
cmovl P0, P1
cmp S1, S0
cmovg S0, S1
cmovl S2, S1
cmp P0, P2
cmovge P3, P0
