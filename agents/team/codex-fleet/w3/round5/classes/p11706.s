# n=5 model=out iset=I1 prefix14_class=11706
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
mov S1, P3
cmovl P2, S0
cmp P1, P3
mov S2, P2
cmovle P3, P1
cmovge S1, P1
cmp P0, S1
cmovge P1, P0
cmovle P1, S1
cmovg P0, S1
cmovl S1, P0
