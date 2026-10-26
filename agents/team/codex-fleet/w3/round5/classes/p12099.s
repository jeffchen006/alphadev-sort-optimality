# n=5 model=out iset=I1 prefix14_class=12099
cmp P3, P0
mov S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P1, P2
mov S2, P2
cmovl P2, P1
mov S0, P2
cmovle P1, S2
cmp P2, S1
cmovle S0, S1
cmovg P2, S1
cmp P1, P3
cmovge S1, S0
