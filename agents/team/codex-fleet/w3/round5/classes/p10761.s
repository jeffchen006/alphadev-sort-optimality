# n=5 model=out iset=I1 prefix14_class=10761
cmp P2, P0
mov S0, P0
cmovle S0, P2
cmovge P0, P2
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
cmovl P0, S2
cmp S0, P1
cmovg S1, P1
