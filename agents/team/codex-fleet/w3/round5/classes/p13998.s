# n=5 model=out iset=I1 prefix14_class=13998
mov S2, P1
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P1, P3
cmovg P1, P3
cmovg P3, S2
cmp P3, P2
mov S2, P3
cmovle S2, P2
cmovge P3, P2
cmp P0, P1
cmovg S0, P0
