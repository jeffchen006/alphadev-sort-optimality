# n=5 model=out iset=I1 prefix14_class=6685
mov S2, P2
cmp P3, P1
cmovle S0, P1
cmovl P1, P3
cmovl P3, S0
cmp P0, S2
cmovl P2, P0
cmovle P0, S2
cmp P0, P3
cmovl S1, P3
cmovle P3, P0
cmovge S1, P0
cmp P2, P1
cmovge S0, P1
