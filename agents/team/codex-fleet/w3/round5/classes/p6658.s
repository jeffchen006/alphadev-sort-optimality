# n=5 model=out iset=I1 prefix14_class=6658
cmp P0, P3
mov S0, P3
cmovle P3, P0
cmovge S0, P0
cmp P1, P2
mov S2, S0
cmovg P0, P1
cmovg P1, P2
cmovle P0, P2
cmp P0, S0
cmovg S0, P0
cmovle S2, P0
cmp P1, P3
cmovl P2, P3
