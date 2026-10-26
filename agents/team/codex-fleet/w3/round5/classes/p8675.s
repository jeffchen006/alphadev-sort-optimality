# n=5 model=out iset=I1 prefix14_class=8675
cmp P1, P3
cmovg S1, P1
cmovg P1, P3
cmovle S1, P3
mov S0, S1
cmp P2, P0
cmovle P3, P0
cmovl P0, P2
cmovl P2, P3
cmp P2, S0
cmovge S1, P2
cmovg P2, S0
cmp P0, P1
cmovge S0, P1
