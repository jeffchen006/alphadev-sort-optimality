# n=5 model=out iset=I1 prefix14_class=10068
cmp P1, P2
mov S0, P1
mov S2, P3
cmovge P1, P2
cmovl S0, P2
cmp P0, S2
cmovl P3, P0
mov S1, S0
cmovg S2, P0
cmp S0, S2
cmovle S1, S2
mov S1, P1
cmovg S0, S2
mov S2, S0
