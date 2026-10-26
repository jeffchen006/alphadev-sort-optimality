# n=5 model=out iset=I1 prefix14_class=10665
cmp P1, P0
mov S0, P3
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
mov S2, P1
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmp P1, P2
cmovg P1, P2
cmovge P2, S2
cmp P0, S0
mov S2, P1
