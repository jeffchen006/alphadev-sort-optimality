# n=5 model=out iset=I1 prefix14_class=4815
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovg S0, P2
mov P2, P1
cmp P2, P0
cmovg P2, P0
cmovg P0, P1
mov S2, P2
cmp P3, P2
cmovle S2, P3
cmovg P2, P3
cmp P0, S0
cmovle S2, S0
