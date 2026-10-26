# n=5 model=out iset=I1 prefix14_class=10724
mov S2, P0
cmp P2, S2
cmovl S2, P2
cmovle P2, P0
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovle P3, S1
mov S0, P2
cmp P2, P1
cmovg S0, P1
cmovg P1, P2
cmp P3, S2
cmovge S1, P3
