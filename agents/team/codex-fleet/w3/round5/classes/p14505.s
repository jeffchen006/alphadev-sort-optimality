# n=5 model=out iset=I1 prefix14_class=14505
cmp P3, P2
mov S0, P3
cmovg S0, P2
mov S2, S0
cmovge P2, P3
mov S1, P1
cmp P0, P1
cmovl P1, P0
cmovl P0, S1
cmp S2, P1
cmovle S0, P1
cmovl P1, S2
cmp P0, P2
cmovl P1, P0
