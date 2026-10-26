# n=5 model=out iset=I1 prefix14_class=9169
cmp P2, P1
cmovg S0, P1
cmovle S0, P2
cmovg P1, P2
cmp P0, P3
cmovle P2, P3
cmovl P3, P0
cmovle P0, P2
cmp P3, S0
cmovge S2, P3
cmovg P3, S0
mov P3, P0
cmovge S0, S2
cmp P1, P3
