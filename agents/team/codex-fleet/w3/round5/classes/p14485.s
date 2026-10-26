# n=5 model=out iset=I1 prefix14_class=14485
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
cmovle P1, P2
mov P2, P0
cmp P3, P0
cmovle P0, P3
cmovle P3, P2
cmp P0, S0
mov P2, S0
cmovl S0, P0
cmovg P2, P0
cmp P3, P1
cmovge S0, P3
