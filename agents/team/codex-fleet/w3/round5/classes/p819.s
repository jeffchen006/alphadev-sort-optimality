# n=5 model=out iset=I1 prefix14_class=819
mov S2, P3
cmp S2, P1
cmovge P3, P1
cmovl S2, P1
mov P1, P2
mov S1, S2
cmp P0, P2
cmovge P2, P0
cmovl P1, P0
cmp P2, S1
cmovle S2, P2
cmovg S1, P2
mov S0, S2
cmp P1, P3
