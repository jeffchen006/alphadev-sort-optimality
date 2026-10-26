# n=5 model=out iset=I1 prefix14_class=4508
cmp P0, P3
cmovle S0, P3
cmovg S0, P0
cmovg P0, P3
mov P3, P1
cmp P1, P2
cmovg P1, P2
cmovl P3, P2
cmp P3, S0
cmovge P2, S0
cmovge S0, P3
cmovle P2, P3
cmp P1, P0
cmovge P3, P0
