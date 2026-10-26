# n=5 model=out iset=I1 prefix14_class=738
cmp P3, P2
cmovle S2, P3
cmovg S2, P2
cmovl P3, P2
mov S0, P1
cmp P1, P0
cmovge S0, P0
cmovl P1, P0
cmp P1, P3
cmovle P2, P1
cmovl P1, P3
cmovl P3, P2
mov P2, S0
cmp P2, S2
