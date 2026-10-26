# n=5 model=out iset=I1 prefix14_class=16
mov S1, P3
cmp P0, S1
cmovl S1, P0
cmovl P0, P3
cmp P2, P1
mov S2, S1
mov P3, P2
cmovg P2, P1
cmovge P1, P3
cmp S1, P2
cmovle S2, P2
mov S0, S2
cmovg S1, P2
cmp P1, P0
