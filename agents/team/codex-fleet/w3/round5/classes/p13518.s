# n=5 model=out iset=I1 prefix14_class=13518
mov S2, P0
cmp P0, P3
cmovle S2, P3
cmovl P3, P0
mov P0, P3
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmovg P2, S0
cmp P1, P3
cmovge P3, P1
cmovl P0, P1
cmp P2, S2
cmovle P1, S2
