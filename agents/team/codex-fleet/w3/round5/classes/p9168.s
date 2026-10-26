# n=5 model=out iset=I1 prefix14_class=9168
cmp P3, P1
cmovg S0, P1
cmovle S0, P3
cmovg P1, P3
cmp P0, P2
cmovle P3, P2
cmovl P2, P0
cmovle P0, P3
cmp P2, S0
cmovge S2, P2
cmovg P2, S0
mov P2, P0
cmovge S0, S2
cmp P1, P2
