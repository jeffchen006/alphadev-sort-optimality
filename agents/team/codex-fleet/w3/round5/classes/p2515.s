# n=5 model=out iset=I1 prefix14_class=2515
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
cmp P2, P3
cmovle S2, P3
cmovg S2, P2
cmovle P3, P2
mov S0, P1
cmp P1, S2
cmovge P1, S2
cmovl S0, S2
mov S0, P1
cmp P0, P3
