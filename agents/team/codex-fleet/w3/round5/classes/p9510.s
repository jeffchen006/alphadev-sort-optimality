# n=5 model=out iset=I1 prefix14_class=9510
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P1, P2
mov S1, P1
cmovg S1, P2
cmovg P2, P1
cmp P0, P3
cmovle S0, P0
