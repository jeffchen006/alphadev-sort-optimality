# n=5 model=out iset=I1 prefix14_class=13663
cmp P2, P1
cmovge S2, P1
cmovle S2, P2
cmovle P2, P1
cmp P3, P0
cmovl P1, P3
mov S0, S2
cmovl P3, P0
cmovl P0, P1
cmp P2, P3
mov S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P0, S0
