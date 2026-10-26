# n=5 model=out iset=I1 prefix14_class=3582
cmp P0, P2
cmovl S0, P0
cmovl P0, P2
cmovl P2, S0
mov S2, P1
cmp P3, S2
cmovge P1, P3
cmovle S2, P3
mov S1, P0
cmp S2, P2
cmovle S0, S2
cmovg S0, P2
cmovge P2, S2
mov S0, P2
