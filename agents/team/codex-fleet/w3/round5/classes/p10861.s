# n=5 model=out iset=I1 prefix14_class=10861
mov S1, P0
cmp P0, P2
cmovg S1, P2
cmovle P0, P2
cmp P1, P3
mov S2, P1
cmovle S2, P3
cmovl P3, P1
mov S0, P0
cmp S2, S0
cmovg S0, S2
cmovle P0, S2
cmp S1, P3
cmovle S2, P3
