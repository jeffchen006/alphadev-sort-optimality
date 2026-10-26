# n=5 model=out iset=I1 prefix14_class=8921
cmp P2, P1
mov S2, P1
cmovl P1, P2
cmovl P2, S2
mov S0, P0
cmp P3, S0
cmovl S0, P3
cmovle P3, P0
cmp P2, P3
cmovle S2, P2
cmovg S2, P3
cmovl P2, P3
cmp P1, S0
cmovge P2, S0
