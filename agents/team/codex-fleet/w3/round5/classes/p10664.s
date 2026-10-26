# n=5 model=out iset=I1 prefix14_class=10664
cmp P1, P0
mov S0, P2
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
mov S2, P1
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmp P1, P3
cmovg P1, P3
cmovge P3, S2
cmp P0, S0
mov S2, P1
