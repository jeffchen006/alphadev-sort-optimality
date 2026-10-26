# n=5 model=out iset=I1 prefix14_class=1733
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
mov S1, P0
cmovle P2, S2
cmp P3, P0
cmovg S1, P3
cmovge P3, P0
mov P1, S0
cmp P2, S0
