# n=5 model=out iset=I1 prefix14_class=2513
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P2, P3
mov S2, P3
cmovg S2, P2
cmovle P3, P2
mov S0, P1
cmp P1, S2
cmovg P1, S2
cmovle S0, S2
cmp P3, P0
cmovge S2, P3
