# n=5 model=out iset=I1 prefix14_class=12788
cmp P0, P2
cmovle S1, P2
mov S0, P1
cmovle P2, P0
cmovl P0, S1
cmp P3, P1
cmovle S0, P3
cmovg P1, P3
cmp P2, S0
mov P3, P1
cmovge S1, P2
cmovg P2, S0
cmovg S0, S1
cmp P3, P0
