# n=5 model=out iset=I1 prefix14_class=2117
cmp P1, P0
cmovg S2, P0
cmovge P0, P1
cmovle S2, P1
mov P1, P3
cmp P1, P2
cmovl P1, P2
cmovg P3, P2
cmp P1, P0
mov P2, P1
cmovg P1, P0
cmovle P2, P0
cmp P3, S2
cmovl S0, P3
