# n=5 model=out iset=I1 prefix14_class=9710
mov S2, P2
cmp P0, P1
mov S0, P1
cmovg P1, P0
cmovge P0, S0
cmp P3, P2
cmovg S2, P3
cmovl P2, P3
mov P3, P2
cmp S2, P1
cmovle S1, P1
cmovl P1, S2
cmovl S2, S1
cmp P3, P0
