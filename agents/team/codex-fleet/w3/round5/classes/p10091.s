# n=5 model=out iset=I1 prefix14_class=10091
cmp P0, P2
mov S0, P0
cmovle S0, P2
mov S2, P1
cmovl P2, P0
cmp S2, P3
cmovge P1, P3
cmovle S2, P3
cmp S2, S0
mov P3, S2
cmovl P3, S0
cmovle S0, S2
cmp P2, P1
cmovl S2, S0
